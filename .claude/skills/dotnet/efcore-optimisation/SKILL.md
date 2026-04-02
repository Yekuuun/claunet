---
name: EF Core Query Optimization
description: Analyze and optimize Entity Framework Core queries for performance
keywords: ["entity framework", "EF", "query", "performance", "optimization", "n+1", "include"]
---

# EF Core Query Optimization Skill

When you detect C# code using Entity Framework Core, activate this skill to:

## 1. Detect N+1 Query Problems
```csharp
// BAD: N+1 queries (1 for users, N for each user's orders)
var users = context.Users.ToList();
foreach (var user in users)
{
    var orders = context.Orders.Where(o => o.UserId == user.Id).ToList(); // N queries!
}

// GOOD: Single query with Include
var users = context.Users
    .Include(u => u.Orders)
    .ToList();
```

Identify:
- Lazy loading in loops
- Missing `.Include()` statements
- Separate queries for related data
- ToList() called too early in query chain

## 2. Optimize Query Structure
Suggest improvements:

```csharp
// Check for:
// - Filtering BEFORE Include() for better performance
// - Using .AsNoTracking() for read-only queries
// - Projection to DTO to reduce payload
// - Split queries for large collections

var orders = context.Users
    .Where(u => u.IsActive)
    .Include(u => u.Orders.Where(o => o.Status == "Pending"))
    .AsNoTracking()
    .Select(u => new UserOrdersDto { ... })
    .ToList();
```

## 3. Analyze Query Execution
Examine:
- **Query Complexity**: How many joins? How deep?
- **Data Transfer**: Loading entire entities vs needed fields only?
- **Filtering Location**: Client-side vs database?
- **Caching Strategy**: Should results be cached?

## 4. Provide Optimization Steps

**Priority Issues**:
- N+1 queries → Critical (add `.Include()`)
- Loading unnecessary fields → High (use `.Select()`)
- Client-side filtering → High (move `.Where()` before `.ToList()`)
- Missing `.AsNoTracking()` → Medium (read-only queries)

**Code Suggestions**:
```csharp
// BEFORE
var products = context.Products.ToList();
var active = products.Where(p => p.IsActive).ToList();

// AFTER
var activeProducts = context.Products
    .Where(p => p.IsActive)
    .AsNoTracking()
    .Select(p => new ProductDto { Id = p.Id, Name = p.Name })
    .ToList();
```

## 5. Check for Split Queries
For large collections, suggest split queries:

```csharp
.AsSplitQuery() // Separate SQL queries for collections
```

## 6. Performance Metrics
Estimate impact:
- Expected query reduction: "1 query instead of 51"
- Estimated time savings: "250ms → 15ms"
- Memory reduction: "5MB → 0.5MB"

## 7. Index Recommendations
If filtering/sorting frequently by a column:
```csharp
// In entity config
modelBuilder.Entity<User>()
    .HasIndex(u => u.Email)
    .IsUnique();
```

## 8. Async Handling
Ensure:
- All DB calls are `async`
- Using `ConfigureAwait(false)` in libraries
- Proper `CancellationToken` passing

## Questions to Ask
1. Is this query in a loop?
2. Are all related data loaded in one query?
3. Is only needed data selected (not entire entities)?
4. Should this use `.AsNoTracking()`?
5. Are indexes needed for performance?
6. Could this be cached?

## Output Format
Provide:
1. **Issues Found** with severity (Critical/High/Medium)
2. **Optimized Code** with detailed comments
3. **Performance Impact** (estimated time/memory improvement)
4. **Explanation** of why each change helps
5. **Testing Notes** (verify behavior matches before/after)