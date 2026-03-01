# Tactical Patterns

Use these patterns to model the Domain Layer.

## Aggregates

- **Definition**: Transactional consistency boundary with a single root entity.
- **Rules**:
  - Keep aggregates small — prefer fewer entities per aggregate.
  - Reference other aggregates by ID, never by direct object reference.
  - One transaction per aggregate — never modify multiple aggregates in one transaction.
  - Encapsulate business rules within the aggregate root.

## Entities

- **Definition**: Identity-based objects with a lifecycle.
- **Rules**:
  - Equality is determined by ID, not attributes.
  - State changes happen through defined methods, not raw public setters.

## Value Objects

- **Definition**: Objects purely defined by their values, with no conceptual identity.
- **Rules**:
  - Immutable — always create new instances instead of changing properties.
  - Equality is determined by all attributes matching.
  - Examples: Money, Address, DateRange, Email.

## Domain Events

- **Definition**: Communicate facts or changes across boundaries.
- **Rules**:
  - Named in past tense: `OrderPlaced`, `PaymentProcessed`.
  - Carry only necessary data required by subscribers, not the entire aggregate state.

## Ports / Adapters (Hexagonal Architecture)

- **Rules**:
  - Domain defines interfaces (Ports).
  - Infrastructure implements them (Adapters).
  - Domain NEVER depends on infrastructure.
