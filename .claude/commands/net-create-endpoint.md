---
description: Generate a new API endpoint with validation, error handling, and tests
argument-hint: <endpoint name and method>
---

# Create New API Endpoint

Generate a production-ready API endpoint with validation, logging, error handling, and integration tests.

Example: "POST /api/users - create user"

For the provided endpoint, create:

## 1. Request DTO
- Use `record` for immutability
- Add FluentValidation rules
- Add XML documentation

```csharp
/// <summary>Request to create a new user</summary>
public record CreateUserRequest(
    /// <summary>User email address (must be unique)</summary>
    string Email,
    /// <summary>User display name</summary>
    string Name,
    /// <summary>User role (Admin, User, Guest)</summary>
    string Role);
```

## 2. Validator
- Using FluentValidation
- Check all business rules
- Provide clear error messages

## 3. Response DTO
- Use `record` for immutability
- Include all relevant fields
- Match API response format

## 4. Endpoint Handler
- Minimal API format
- Input validation
- Error handling with proper HTTP status codes
- Structured logging with correlation ID
- Async/await with CancellationToken

```csharp
app.MapPost("/api/users", CreateUserHandler)
    .RequireAuthorization()
    .Produces<UserResponse>(StatusCodes.Status201Created)
    .Produces(StatusCodes.Status400BadRequest)
    .WithName("CreateUser")
    .WithOpenApi();
```

## 5. Service Method
- Clear, focused responsibility
- Proper exception handling
- Async with cancellation token
- Return domain results

## 6. Integration Test
- Setup test data
- Call endpoint
- Assert response and status code
- Verify database changes
- Use real SQL Server with Testcontainers

## 7. Unit Test
- Test validator
- Test service logic
- Mock dependencies
- Test error scenarios

## 8. Database Changes
- Create/update entity if needed
- Add EF Core migration
- Ensure backwards compatibility

Include:
- Clear code comments
- XML documentation on public members
- Proper error handling with specific exceptions
- Logging at DEBUG (entry), INFO (important), ERROR (failures)
- Performance considerations (indexes, query optimization)