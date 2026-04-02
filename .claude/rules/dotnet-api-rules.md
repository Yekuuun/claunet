---
paths: ["src/YourApp.Api/Endpoints/**/*.cs"]
---

# API Endpoints Rules

## Input Validation
Every endpoint must validate input **before** touching business logic:

```csharp
app.MapPost("/api/users", async (CreateUserDto request, IValidator<CreateUserDto> validator) =>
{
    var validation = await validator.ValidateAsync(request);
    if (!validation.IsValid)
        return Results.BadRequest(validation.Errors.Select(e => e.ErrorMessage));
    
    // Business logic here
});
```

## Response Format
All responses must follow standard format:

- Success: `{ "data": {...}, "success": true }`
- Error: `{ "errors": ["error message"], "success": false }`
- Never expose stack traces or internal details

## HTTP Status Codes
- `200 OK` - successful GET/PUT
- `201 Created` - successful POST with resource creation
- `204 No Content` - successful DELETE
- `400 Bad Request` - validation failure
- `401 Unauthorized` - authentication required
- `403 Forbidden` - authenticated but not authorized
- `404 Not Found` - resource doesn't exist
- `500 Internal Server Error` - only for unexpected errors (log with correlation ID)

## Authentication
Every endpoint (except public list) must have `[Authorize]` attribute:

```csharp
app.MapPost("/api/sensitive", async (Request request) =>
{
    // ClaimsPrincipal available via HttpContext
})
.RequireAuthorization();
```

## Logging
Use structured logging on all endpoints:

```csharp
logger.LogInformation("User {UserId} created account {@Request}", userId, request);
logger.LogError(ex, "Failed to process order {OrderId}", orderId);
```

Do NOT log:
- Passwords or sensitive tokens
- Personal identification numbers
- Credit card info
- API keys

## Error Handling
Catch specific exceptions, translate to HTTP responses:

```csharp
catch (ValidationException ex)
    return Results.BadRequest(ex.Errors);
catch (NotFoundException ex)
    return Results.NotFound(ex.Message);
catch (UnauthorizedException ex)
    return Results.Unauthorized();
catch (Exception ex)
{
    logger.LogError(ex, "Unexpected error in {Endpoint}", nameof(MyEndpoint));
    return Results.StatusCode(500);
}
```

## Async/Await
- All I/O operations (DB, HTTP, file) must be `async`
- Always use `await` in handlers
- Never use `.Result` or `.Wait()`
- Pass `CancellationToken ct` through the chain

```csharp
app.MapGet("/api/users/{id}", async (int id, CancellationToken ct, IUserService service) =>
    await service.GetUserAsync(id, ct));
```

## Performance
- Use `.AsNoTracking()` for read-only queries
- Use `.Include()` to prevent N+1 queries
- Validate early, execute late
- Return only necessary fields (DTOs, not entities)