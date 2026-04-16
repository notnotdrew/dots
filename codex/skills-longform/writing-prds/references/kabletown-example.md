# Kabletown PRD Example

This example shows the preferred sparse-milestone PRD style: one unified use case compendium, milestone values only for the first milestone, and only Milestone 1 defined.

# Product Requirements Document: Helpy McHelpface

## High-Level Requirements

- Per the Product Brief, the product should increase user satisfaction and reduce support burden while remaining revenue neutral.
- The first milestone prioritizes technical support interactions for the Sad Lisa persona.
- The first release focuses on frequent technical diagnosis flows before account-management complexity.
- When the assistant is uncertain or outside its expertise, it should escalate to a human instead of improvising.

## Use Case Compendium

| Requirement | Milestone | Persona | North Star |
|-------------|-----------|---------|------------|
| Lisa can find Helpy on the home page without logging in when she needs technical support | 1.0 | Sad Lisa | Customer hardware problem |
| Helpy is clearly visible as a support entry point before login | | Sad Lisa | Customer hardware problem |
| Helpy can gather setup information through guided questions | 1.0 | Sad Lisa | Customer hardware problem |
| Helpy can check outage status for the user's location before starting diagnostics | 1.0 | Sad Lisa | Outage |
| When an outage exists, Helpy tells the user and provides an ETA | 1.5 | Sad Lisa | Outage |
| Helpy can guide Lisa through common slow-internet diagnostics | 1.0 | Sad Lisa | Customer hardware problem |
| Helpy suggests interventions in a helpful order based on prior success | 1.5 | Sad Lisa | Customer hardware problem |
| When remediation is inconclusive, Helpy suggests next follow-up actions before ending the conversation | | Sad Lisa | Customer hardware problem |
| Lisa is presented a satisfaction survey after support interactions | | Sad Lisa | Customer hardware problem |
| Users can request a human support representative at any time | 1.0 | Both | Angry customer |
| When escalating, Helpy transfers the conversation context to the human agent | | Both | Angry customer |
| Helpy recognizes frustration and offers escalation to a human | | Both | Angry customer |
| Helpy can send follow-up notifications when outages are resolved | | Sad Lisa | Outage |
| Helpy asks Lisa what worked so it can keep learning over time | | Sad Lisa | Customer hardware problem |
| Helpy can learn from satisfaction survey results to improve future guidance | | Sad Lisa | Customer hardware problem |
| Tia can find Helpy while logged into her account | | Tinker Tia | Cable box installation |
| Helpy can access Tia's account details when account-specific help is required | | Tinker Tia | Cable box installation |
| Helpy can explain available plan options and their costs | | Tinker Tia | Downgrade |
| Helpy can guide users through adding equipment to their plan | | Tinker Tia | Cable box installation |
| Helpy can determine whether professional installation is required | | Tinker Tia | Cable box installation |
| Helpy can initiate equipment shipping orders | | Tinker Tia | Cable box installation |
| Helpy can coordinate installation appointment scheduling after shipment | | Tinker Tia | Cable box installation |
| Helpy can process subscription changes after explicit confirmation | | Tinker Tia | Downgrade |
| Helpy can explain why some downgrade requests would not reduce cost and offer alternatives | | Tinker Tia | Angry customer |

## Milestone Definitions

### Milestone 1: Technical Support Foundation
**Goal**: Prove that Helpy can successfully handle common technical support issues while improving customer satisfaction and reducing support burden.

**Persona focus**: Sad Lisa

**North star scenario**: Customer hardware problem, with outage handling and safe escalation as supporting paths

**Scope**:
- pre-login discoverability for technical support
- outage detection and communication
- guided diagnosis for common slow-internet issues
- ordered intervention suggestions
- satisfaction measurement and safe human escalation

**Explicitly excluded**:
- account modifications, which require authenticated higher-risk actions
- learning systems, which can begin with manual analysis first
- equipment ordering and installation scheduling, which belong to a later milestone
- plan comparison and downgrade flows, which serve a different persona and workflow
