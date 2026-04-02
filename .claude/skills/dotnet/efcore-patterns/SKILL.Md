---

name: efcore-patterns
description: > Entity Framework Core best practices including NoTracking by default, query splitting for navigation collections, migration management, dedicated migration services, and common pitfalls to avoid.

---

# Entity Framework Core Patterns

## When to Use This Skill

Use this skill when:
- Setting up EF Core in a new project
- Optimizing query performance
- Managing database migrations
- Integrating EF Core with .NET Aspire
- Debugging change tracking issues
- Loading multiple navigation collections efficiently (query splitting)

## Core Principles

1. **NoTracking by Default** - Most queries are read-only; opt-in to tracking
2. **Never Edit Migrations Manually** - Always use CLI commands
3. **Dedicated Migration Service** - Separate migration execution from application startup
4. **ExecutionStrategy for Retries** - Handle transient database failures
5. **Explicit Updates** - When NoTracking, explicitly mark entities for update

---

## Pattern 1: NoTracking by Default

Configure your DbContext to disable change tracking by default. This improves performance for read-heavy workloads.

```csharp
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
        // Disable change tracking by default for better performance on read-only queries
        // Use .AsTracking() explicitly for queries that need to track changes
        ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
    }

    public DbSet<Order> Orders => Set<Order>();
    public DbSet<Customer> Customers => Set<Customer>();
}
```

### When NoTracking is Active

**Read-only queries work normally:**
```csharp
// ✅ Fast read - no tracking overhead
var orders = await dbContext.Orders
    .Where(o => o.Status == OrderStatus.Pending)
    .ToListAsync();
```

**Writes require explicit handling:**
```csharp
// ❌ WRONG - Entity not tracked, SaveChanges does nothing
var order = await dbContext.Orders.FirstOrDefaultAsync(o => o.Id == orderId);
order.Status = OrderStatus.Shipped;
await dbContext.SaveChangesAsync(); // Nothing happens!

// ✅ CORRECT - Explicitly mark entity for update
var order = await dbContext.Orders.FirstOrDefaultAsync(o => o.Id == orderId);
order.Status = OrderStatus.Shipped;
dbContext.Orders.Update(order); // Marks entire entity as modified
await dbContext.SaveChangesAsync();

// ✅ ALSO CORRECT - Use AsTracking() for the query
var order = await dbContext.Orders
    .AsTracking()
    .FirstOrDefaultAsync(o => o.Id == orderId);
order.Status = OrderStatus.Shipped;
await dbContext.SaveChangesAsync(); // Works!
```

### When to Use Tracking

| Scenario | Use Tracking? | Why |
|----------|---------------|-----|
| Display data in UI | No | Read-only, no updates |
| API GET endpoints | No | Returning data, no mutations |
| Update single entity | Yes or explicit Update() | Need to save changes |
| Complex update with navigation | Yes | Tracking handles relationships |
| Batch operations | No + ExecuteUpdate | More efficient |

### Explicit Add/Update Pattern

```csharp
public class OrderService
{
    private readonly ApplicationDbContext _db;

    // CREATE - Always use Add (works regardless of tracking)
    public async Task<Order> CreateOrderAsync(Order order)
    {
        _db.Orders.Add(order);
        await _db.SaveChangesAsync();
        return order;
    }

    // UPDATE - Explicitly mark as modified
    public async Task UpdateOrderStatusAsync(Guid orderId, OrderStatus newStatus)
    {
        var order = await _db.Orders.FirstOrDefaultAsync(o => o.Id == orderId)
            ?? throw new NotFoundException($"Order {orderId} not found");

        order.Status = newStatus;
        order.UpdatedAt = DateTimeOffset.UtcNow;

        // Explicitly mark as modified since DbContext uses NoTracking by default
        _db.Orders.Update(order);
        await _db.SaveChangesAsync();
    }

    // DELETE - Attach and remove
    public async Task DeleteOrderAsync(Guid orderId)
    {
        var order = new Order { Id = orderId };
        _db.Orders.Remove(order);
        await _db.SaveChangesAsync();
    }
}
```

---

## Pattern 2: Never Edit Migrations Manually

NEVER TOUCH TO MIGRATIONS WITHOUT PERMISSIONS.

---

## Common Pitfalls

### 1. Forgetting to Update When NoTracking

```csharp
// ❌ Silent failure - entity not tracked
var customer = await _db.Customers.FindAsync(id);
customer.Name = "New Name";
await _db.SaveChangesAsync(); // Does nothing!

// ✅ Explicit update
var customer = await _db.Customers.FindAsync(id);
customer.Name = "New Name";
_db.Customers.Update(customer);
await _db.SaveChangesAsync();
```

### 2. N+1 Query Problem

```csharp
// ❌ N+1 queries - one query per order
var customers = await _db.Customers.ToListAsync();
foreach (var customer in customers)
{
    var orders = customer.Orders; // Lazy load triggers query
}

// ✅ Eager loading - single query
var customers = await _db.Customers
    .Include(c => c.Orders)
    .ToListAsync();
```

### 3. Tracking Conflicts with Multiple DbContext Instances

```csharp
// ❌ Tracking conflict - entity tracked by different context
var order1 = await _db1.Orders.AsTracking().FindAsync(id);
var order2 = await _db2.Orders.AsTracking().FindAsync(id);
order2.Status = OrderStatus.Shipped;
await _db2.SaveChangesAsync(); // May throw or behave unexpectedly

// ✅ Use single context or detach first
_db1.Entry(order1).State = EntityState.Detached;
```

### 4. Not Using Async Consistently

```csharp
// ❌ Blocking call in async context
var orders = _db.Orders.ToList(); // Blocks thread

// ✅ Async all the way
var orders = await _db.Orders.ToListAsync();
```

### 5. Querying Inside Loops

```csharp
// ❌ Query per iteration
foreach (var orderId in orderIds)
{
    var order = await _db.Orders.FindAsync(orderId);
    // process order
}

// ✅ Single query
var orders = await _db.Orders
    .Where(o => orderIds.Contains(o.Id))
    .ToListAsync();
```

---

## Testing with EF Core

### In-Memory Provider (Unit Tests Only)

```csharp
// Only for simple unit tests - doesn't match real database behavior
var options = new DbContextOptionsBuilder<ApplicationDbContext>()
    .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
    .Options;

using var context = new ApplicationDbContext(options);
```

### Real Database with TestContainers (Integration Tests)

See the `testcontainers-integration-tests` skill for proper database testing.

```csharp
// Use real PostgreSQL in container
var container = new PostgreSqlBuilder()
    .WithImage("postgres:16-alpine")
    .Build();

await container.StartAsync();

var options = new DbContextOptionsBuilder<ApplicationDbContext>()
    .UseNpgsql(container.GetConnectionString())
    .Options;
```