---
paths: ["tests/**/*.cs"]
---

# Unit & Integration Tests Rules

## AAA Pattern (Required)
Every test must follow Arrange, Act, Assert:

```csharp
[Fact]
public async Task CreateUser_WithValidData_ReturnsCreatedUser()
{
    // Arrange
    var request = new CreateUserDto { Email = "test@example.com", Name = "Test" };
    var validator = new CreateUserValidator();
    
    // Act
    var result = await validator.ValidateAsync(request);
    
    // Assert
    Assert.True(result.IsValid);
}
```

## Naming Convention
- Test method: `{MethodName}_Given{Condition}_Expect{Result}`
- Example: `ProcessOrder_GivenInvalidQuantity_ThrowsException`
- Or: `CalculateDiscount_WithPremiumCustomer_Returns10Percent`

## Mocking Rules

### ILogger Mocking
```csharp
var loggerMock = new Mock<ILogger<MyService>>();
// Use It.IsAny<LogLevel>() for flexibility
loggerMock.Verify(x => x.Log(
    It.IsAny<LogLevel>(),
    It.IsAny<EventId>(),
    It.IsAny<It.IsAnyType>(),
    It.IsAny<Exception>(),
    It.IsAny<Func<It.IsAnyType, Exception, string>>()),
    Times.Once);
```

### Repository/Service Mocking
```csharp
var repositoryMock = new Mock<IUserRepository>();
repositoryMock
    .Setup(r => r.GetByIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
    .ReturnsAsync(testUser);
```

## Test Isolation
- Each test is independent
- No shared state between tests
- Use fixtures for setup only
- Clean up after tests (transactions, temp files)

```csharp
public async Task MyTest_WithCondition_Expects()
{
    // Arrange - setup
    var testData = new TestFixture().CreateUser();
    
    // Act
    var result = await service.ProcessAsync(testData);
    
    // Assert
    Assert.NotNull(result);
} // Database transaction auto-rolls back
```

## Integration Tests
Use `Testcontainers` for real SQL Server:

```csharp
public class UserRepositoryIntegrationTests : IAsyncLifetime
{
    private readonly MsSqlContainer _container = new MsSqlBuilder().Build();
    
    public async Task InitializeAsync() => await _container.StartAsync();
    public async Task DisposeAsync() => await _container.StopAsync();
    
    [Fact]
    public async Task GetUser_WithValidId_ReturnsUser()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlServer(_container.GetConnectionString())
            .Options;
        
        using var context = new AppDbContext(options);
        // Test against real DB
    }
}
```

## Coverage Requirements
- **Application layer**: minimum 80%
- **Domain logic**: minimum 90%
- **Infrastructure**: minimum 60% (harder to test)
- **API endpoints**: integration tests cover critical paths

## Exception Testing
```csharp
[Fact]
public async Task DeleteUser_WithNonExistentId_ThrowsNotFoundException()
{
    // Arrange
    var service = new UserService(repositoryMock.Object);
    
    // Act & Assert
    var exception = await Assert.ThrowsAsync<NotFoundException>(
        () => service.DeleteAsync(999));
    
    Assert.Equal("User not found", exception.Message);
}
```

## Data Builders
Use builders for complex test objects:

```csharp
var user = new UserBuilder()
    .WithEmail("test@example.com")
    .WithRole(UserRole.Admin)
    .Build();
```

## Test Traits (Categorize Tests)
```csharp
[Trait("Category", "UnitTest")]
[Fact]
public void CalculateTotal_WithDiscount_ReturnsDiscountedPrice() { }

[Trait("Category", "IntegrationTest")]
[Fact]
public async Task CreateUser_InDatabase_Success() { }
```

## Performance Constraints
- Unit tests: < 10ms per test
- Integration tests: < 500ms per test
- Total suite: < 2 minutes

## Assertions Library
Prefer FluentAssertions for readability:

```csharp
// Instead of Assert.Equal
result.Should().Be(expected);

// Instead of Assert.NotNull
result.Should().NotBeNull();

// Instead of Assert.Contains
result.Errors.Should().Contain(e => e.PropertyName == "Email");
```