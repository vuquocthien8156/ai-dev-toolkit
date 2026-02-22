---
name: ddd-core-rules
description: >
  DDD best practices for any project. Aggregate rules, layer dependencies,
  tactical patterns (Entity, Value Object, Domain Event, Port/Adapter).
  Sources: Eric Evans, Martin Fowler, nestjslatam/ddd.
---

# DDD Core Rules

## Strategic Patterns

- **Ubiquitous Language**: Shared terms between code and domain experts. Name classes, methods, and variables using domain language.
- **Bounded Context**: Clear boundary where a domain model applies. Do not leak models across contexts.
- **Context Mapping**: Define relationships between bounded contexts (Shared Kernel, Anti-Corruption Layer, Conformist, etc.)

## Tactical Patterns

### Aggregates

- Transactional consistency boundary with a single root entity
- Keep aggregates small — prefer fewer entities per aggregate
- Reference other aggregates by ID, never by direct object reference
- One transaction per aggregate — never modify multiple aggregates in one transaction
- Encapsulate business rules within the aggregate root

### Entities

- Identity-based objects with lifecycle
- Equality determined by ID, not attributes
- Can change state through defined methods

### Value Objects

- Immutable — always create new instances for changes
- Equality determined by all attributes, not identity
- No ID — purely defined by their values
- Examples: Money, Address, DateRange, Email

### Domain Events

- Communicate changes across aggregates
- Named in past tense: `OrderPlaced`, `PaymentProcessed`
- Carry only necessary data, not the entire aggregate

### Ports / Adapters (Hexagonal Architecture)

- Domain defines interfaces (Ports)
- Infrastructure implements them (Adapters)
- Domain NEVER depends on infrastructure

## Layer Dependency Rules

```
Domain ← Application ← Infrastructure ← Presentation

Domain layer MUST NOT import from:
  - Framework (NestJS, Express, Spring)
  - ORM (TypeORM, Prisma, Sequelize)
  - External services (Stripe, AWS, SendGrid)

Application layer:
  - Orchestrates domain logic via Use Cases / Command Handlers
  - Each Use Case = single execute() method
  - Depends on domain interfaces (Ports), never on implementations

Infrastructure layer:
  - Implements domain Ports (Repository interfaces, Gateway interfaces)
  - Contains ORM entities, API clients, queue consumers, email services
  - Handles serialization/deserialization between domain and persistence

Presentation layer:
  - HTTP controllers, GraphQL resolvers, CLI handlers
  - Thin — only routing + validation + DTO mapping
  - Never contains business logic
```

## Anti-Patterns to Avoid

- ❌ Anemic Domain Model — entities with only getters/setters, no behavior
- ❌ God Aggregate — aggregate with too many entities and responsibilities
- ❌ Cross-aggregate transactions — modifying multiple aggregates in one transaction
- ❌ Domain depending on infrastructure — importing ORM or framework in domain layer
- ❌ Leaking domain objects to presentation — always use DTOs at boundaries

## References

- Eric Evans, "Domain-Driven Design: Tackling Complexity in the Heart of Software" (Blue Book)
- Martin Fowler, Patterns of Enterprise Application Architecture
- [nestjslatam/ddd](https://github.com/nestjslatam/ddd) — NestJS + CQRS + Sagas
- [Sairyss/domain-driven-hexagon](https://github.com/Sairyss/domain-driven-hexagon) — Reference architecture (3.5k⭐)
