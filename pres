---
marp: true
theme: rose-pine 
style: |
  .columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
  .columns3 {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: rem;
  }

---

# Cloud Cost Optimization 
###  Marius Nygård 
Platform Engineer/DevOps Engineer @Crayon Consulting

---

# Goal 
Given that we have a lot of expensive workloads in the cloud, how can we think about cost optimization and what are the main levers we can utilize?

This talk will focus on the following:
- Finding good metrics and thinking throuhg how to optimize for them
- How to gain insights into how different instance types perform for different workloads
- How to use telemetry to get insights into our workloads
  - And spesificly what metrics are the most relevant for choosing the right instance

---

# Problem Context
Some assumptions/prerequisites for that make this type of optimization relevant:

- You have the ability to change the instance type of your workloads
  - Auto scaling groups (or equivalent in other cloud providers)
  - Kubernetes workloads
  - Managed workloads (Azure Container Apps, App Service, etc)
  - Big Data workloads (Spark, Dask, etc)
- HA workloads if uptime is critical
  - Makes experimentation and metrics possible 

---

# Why Is picking the right instance type a problem?
Just to get an idea of the of the problem from a developer perspective:
<div class="columns">
  <div>

  - Multiple cloud providers
  - Hundreds of instance types
  - Different CPU generations
  - Various memory configurations

  </div>
  <div>

  - Different pricing models (reserved/spot/on-demand)
  - Regional price variations
  - Regional instance availability

  </div>  
</div>

<br>
 
And all of this assumes you already have a good idea of what you need.
And your workload might change character over time.
Plus it changes all the time.

---
 
<video style="object-fit: cover;" src="./Screen Recording 2025-03-22 at 18.18.52.mov" width="500px"  controls></video>

---

<h2> Why is understanding the cost profile of your workload difficult?  </h2>

<div class="columns" style="font-size: 20px;">
  <div >

  ## Key Metrics Challenges
  - CPU utilization doesn't tell the whole story
  - Memory usage patterns vary widely
  - I/O bottlenecks often hidden
  - Network constraints unpredictable

  ## Workload Types Complexity
  - Batch jobs: Completion time vs. resource usage
  - Microservices: Complex dependencies
  - Data processing: Spiky resource demands
  - Stateful workloads: Different scaling rules

  </div>
  <div>

  ## Load Pattern Variables  
  - Constant load: Steady, predictable but inefficient
  - Durnal patterns: Daily/weekly cycles
  - Spiky traffic: Hard to provision efficiently
  - Seasonal variations: Holiday traffic

  ## Optimization Focus Areas
  - Instance selection: Highest ROI for many workloads
  - Architecture: Biggest long-term impact
  - Auto-scaling policies: Balancing performance vs cost
  - Data storage choices: Often overlooked cost driver

  </div>  
</div>


---
 
 <img src="./image(2).png" width="900px">

---
 
 <img src="./image.png" width="900px">

---

# How to turn this into a tractable problem?

<div class="columns" style="font-size: 20px;">
  <div>

  ## Metric Approach
  - Our ultimate metric is **money**
  - We can proxy this with **time**
  - Finding cost: time × cost per resource unit
  - Example: $0.05/CPU-hour × 10 hours = $0.50

  ## Efficiency Analysis  
  - Instance utilization metrics reveal waste
  - Underutilized instances = wasted resources
  - Overloaded instances = performance issues
  - Target: optimal resource utilization

  </div>
  <div>

  ## Performance Profiling
  - CPU utilization patterns
  - Memory consumption trends
  - I/O bottlenecks
  - Network throughput
  
  ## Cost Evaluation Framework
  - Current state assessment
  - Performance-to-cost ratio
  - Instance rightsizing opportunity
  - Scaling policy optimization

  </div>  
</div>

---

<h2> How to learn about the performance of different instance types </h2>


<div class="columns" style="font-size: 20px;">
  <div>

  ## Performance Database
  - Built database of workload performance profiles
  - Covers major cloud providers and instance types
  - Normalized performance metrics
  - Historical performance tracking

  </div>
  <div>

  ## Key Profiling Components
  - Micro-benchmarks per CPU type
  - Time-to-completion measurements
  - Throughput per time unit
  - Cost efficiency conversion

  </div>  
</div>

---

# Performance Evaluation Methods

<div class="columns" style="font-size: 20px;">
  <div>

  ## Benchmark Suite Examples
  - SPECcpu: CPU-intensive workloads
  - FFmpeg: Video transcoding performance
  - Nginx: Web server throughput
  - Redis: In-memory data store

  </div>
  <div>

  ## Instance Categories
  - Compute-optimized
  - Memory-optimized
  - General purpose
  - GPU/specialized compute
  - ARM vs. x86 architecture

  </div>  
</div>

We essentialy need to learn what is the best performance per dollar for each instance category

---

# Understanding Your Workload DAG

My preferred way to think about this is to break down your workload into a Directed Acyclic Graph (DAG)

- A DAG represents your workload as a series of connected operations
- Each node represents a processing step
- Edges represent dependencies or data transfer between steps
- Critical path represents the longest sequence that determines overall completion time
- And by adding a time metric to each node you get a overview of where the cost is

---


<div class="columns3">
  <div>

    Example: Simple Data Processing DAG
<img src="./dag1.svg" style="background-color:rgba(228, 228, 228, 0.4);">
  </div>

  <div> </div>

  <div>

    Example: Microservice Architecture DAG
<img src="./dag2.svg" style="background-color:rgba(228, 228, 228, 0.4);">
  </div>

</div>

---

# Optimizing Based on DAG Analysis

<div class="columns" style="font-size: 20px;">
  <div>

  ## Identify Critical Paths
  - Measure time at each node
  - Focus optimization on slowest paths
  - Calculate time × cost for each component
  - Analyze resource utilization per node

  ## Right-sizing Strategies
  - Compute-intensive nodes → CPU optimized
  - Memory-heavy nodes → Memory optimized
  - I/O bound nodes → Storage optimized
  - Network bottlenecks → Enhanced networking

  </div>
  <div>

  ## Scaling Considerations
  - Horizontal vs vertical scaling per node
  - Parallel execution opportunities
  - Queue-based decoupling
  - Caching strategies
  - Batch size optimization

  </div>  
</div>

---

# How to think about cost optimization

<div class="columns" style="font-size: 20px;">
  <div>

  ## Holistic Approach
  - End-to-end processing time you **paid for**
  - Data loading → Processing → Storage
  - Measure time at each DAG node
  - Identify bottlenecks in the workflow

  ## Optimization Principles
  - Focus on critical path components
  - Balance instance cost vs. performance
  - Consider scaling characteristics
  - Account for regional variations
  - Evaluate reserved/spot opportunities

  </div>
  <div>

  ## Real-world Considerations
  - Deployment complexity tradeoffs
  - Operational overhead
  - Reliability requirements
  - Data transfer costs
  - Maintenance windows

  ## Long-term Strategies
  - Regular instance type evaluation
  - Workload-specific benchmarking
  - Reserved instances for stable loads
  - Spot instances for flexible workloads
  - Architecture evolution planning

  </div>  
</div>

---

# Example: Cost Optimization with DAG Analysis
<div style="display: flex; height: 500px; justify-content: center;">
  <img src="./dag3.svg" style="background-color:rgba(228, 228, 228, 0.4);">
</div>

---

# Core concepts

<div class="columns" style="font-size: 20px;">
  <div>

  ## Cost Components
  - Compute: Time × hourly instance cost
  - Network: Ingress/egress traffic charges
  - Storage: Capacity and operation costs
  - Managed services: Usage-based pricing

  ## Proxy Metrics
  - Transaction throughput rate
  - Requests processed per second
  - Data processed per dollar
  - Time-to-completion for batch jobs

  </div>
  <div>

  ## Hidden Costs
  - Developer time for optimization
  - Operational complexity
  - Troubleshooting overhead
  - Cloud architecture expertise
  - Application refactoring

  ## Price Variability
  - Reserved: 30-60% discount with commitment
  - Spot: 70-90% discount with availability risk
  - On-demand: Premium for flexibility
  - Regional price differences: up to 40%

  </div>  
</div>

---

# Over provisioning is not inherently bad

<div class="columns" style="font-size: 20px;">
  <div>

  ## Balancing Tradeoffs
  - Robustness vs. efficiency
  - Performance predictability 
  - Buffer for unexpected spikes
  - Insurance against cascading failures

  ## Strategic Overprovisioning
  - Critical system components
  - Hard-to-scale bottlenecks
  - Customer-facing services
  - Data consistency components

  </div>
  <div>

  ## Cost of Underprovisioning
  - Lost transactions
  - Customer experience impact
  - Cascading system failures
  - Recovery resource needs
  - Business reputation damage
  </div>  
</div>


---
---
---
---
<div class="mermaid">
graph TD
    A[Introduction] --> B[Problem Statement]
    B --> C[Background/Context]
    C --> D[Main Points]
    D --> D1[Key Point 1]
    D --> D2[Key Point 2]
    D --> D3[Key Point 3]
    D1 --> E[Analysis/Discussion]
    D2 --> E
    D3 --> E
    E --> F[Conclusions]
    F --> G[Q&A/Next Steps]
  </div>


---
# mermaid
<div class="mermaid ">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>

---

<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  // mermaid.initialize({ startOnLoad: true, securityLevel: 'loose', theme: 'dark' });
  mermaid.initialize({ startOnLoad: true, securityLevel: 'loose' });
</script>

#TODO:
- add something about price variability between reseved/spot/on-demand
- i should add in some namedropping of partners (Amd, Redhat, Aws, AWS map integration, etc)