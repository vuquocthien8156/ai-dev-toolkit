# Anti-Patterns (What NOT to do)

Avoid these common mistakes in Domain-Driven Design codebases.

## 1. Anemic Domain Model

- **Definition**: Entities with only getters and setters, no behavior or logic.
- **Fix**: Move business logic from Application Services into the Entities themselves.

## 2. God Aggregate

- **Definition**: An aggregate containing too many entities, responsibilities, and logic.
- **Fix**: Identify smaller transactional boundaries. Split the root aggregate or extract distinct aggregates. Reference related aggregates by ID, not object instance.

## 3. Cross-Aggregate Transactions

- **Definition**: Modifying multiple aggregates within a single transaction.
- **Fix**: Use Domain Events. Modify the first aggregate, dispatch an event, handle the event to modify the second aggregate (eventual consistency).

## 4. Domain Depending on Infrastructure

- **Definition**: Importing an ORM (`TypeORM`, `Prisma`), Framework (`NestJS`, `Express`), or External SDK (`Stripe`) into the Domain layer.
- **Fix**: Define interface Ports in the Domain, implement Adapters in Infrastructure.

## 5. Leaking Domain Objects to Presentation

- **Definition**: Returning raw Entities or Aggregates directly from HTTP controllers.
- **Fix**: Always map domain objects to DTOs/ViewModels before exiting the Presentation layer.
