# Environment Template
_A template that's instantiated across all environments_

---

This module is instantiated for every environment.  It is expected that 
non-production environments will override the node pool cardinalities and 
machine types to more economical values. 

> [!CAUTION]
> This template will, by default, instantiate a production class environment
> with node cardinalities and machine types that are sufficient to support a
> production load.  These SHOULD be overridden in non-production environments.

## Overriding Node Pool Configurations

Node pool configurations can be overridden