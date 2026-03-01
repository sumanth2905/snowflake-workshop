# Snowflake Virtual Warehouses - Quick Reference

## What is a Virtual Warehouse?

A Virtual Warehouse is Snowflake's **compute engine** that executes queries. Think of it as the "processing power" that runs your SQL commands.

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Compute, not Storage** | Warehouses process queries but don't store data |
| **Pay per Second** | Charged only when running (minimum 60 seconds) |
| **Independent** | Multiple warehouses can run simultaneously |
| **Instant Scaling** | Start/stop/resize in seconds |

## Warehouse Sizes

| Size | Credits/Hour | Use Case |
|------|--------------|----------|
| X-Small | 1 | Learning, testing, small queries |
| Small | 2 | Development, light workloads |
| Medium | 4 | Production queries, moderate data |
| Large | 8 | Complex queries, large datasets |
| X-Large | 16 | Heavy analytics, many users |
| 2X-Large+ | 32+ | Enterprise-scale workloads |

**Each size = 2x the compute power of the previous size**

## Essential Commands

```sql
-- See all warehouses
SHOW WAREHOUSES;

-- Use a specific warehouse
USE WAREHOUSE COMPUTE_WH;

-- Check current warehouse
SELECT CURRENT_WAREHOUSE();

-- See warehouse details
SHOW WAREHOUSES LIKE 'COMPUTE_WH';

-- Check auto-suspend/resume settings
SHOW PARAMETERS LIKE 'AUTO%' IN WAREHOUSE COMPUTE_WH;
```

## Auto-Suspend & Auto-ResumeAuto-Suspend

### Auto-Suspend
* Automatically stops warehouse after period of inactivity
* Default: 600 seconds (10 minutes)
* **Saves money!** No charges when suspended

### Auto-Resume
* Automatically starts warehouse when you run a query
* Default: Enabled (TRUE)
* First query after resume may take 1-2 seconds longer

## Warehouse States
| State | Description | Billing |
|------|--------------|----------|
| STARTED | Running and ready | ✅ Charged per second |
| SUSPENDED | Stopped, idle | ❌ Not charged |
| RESIZING | Changing size | ✅ Charged |

## Best Practices for Workshops/Learning
1. **Use X-Small warehouse** - Perfect for small datasets
2. **Enable auto-suspend** - Set to 5-10 minutes
3. **Enable auto-resume** - Always keep this ON
4. **Monitor usage** - Check Query History regularly
5. **Suspend manually** - If done for the day: ALTER WAREHOUSE COMPUTE_WH SUSPEND;

## Cost Optimization Tips

✅ DO:
* Start with smallest warehouse that meets needs
* Use auto-suspend (5-10 minutes for dev, 1-2 minutes for prod)
* Separate warehouses for different workloads
* Monitor query performance and adjust size accordingly

❌ DON'T:
* Leave warehouses running when not in use
* Use large warehouses for small queries
* Share one warehouse for all different workloads
* Forget to set auto-suspend


## Common Questions
**Q: Will my data be deleted when the warehouse suspends?**
A: No! Data is stored separately. Suspending a warehouse only stops compute.

**Q: How do I know if my warehouse is running?**
A: Run SHOW WAREHOUSES; and check the 'state' column.

**Q: What happens if I run a query on a suspended warehouse?**
A: It automatically resumes (if auto-resume is enabled), runs your query, then auto-suspends after the timeout period.

**Q: Can multiple people use the same warehouse?**
A: Yes! Warehouses can handle multiple concurrent queries.

**Q: How do I choose the right size?**
A: Start small and scale up if queries are too slow. For learning/testing, X-Small is usually sufficient.

## Workshop Recommendations
For this workshop:
* Warehouse: COMPUTE_WH (X-Small)
* Auto-Suspend: 600 seconds (10 minutes)
* Auto-Resume: TRUE

Remember: Snowflake's separation of storage and compute means you can:
* Stop warehouses without losing data
* Run multiple warehouses simultaneously
* Scale compute up/down instantly
* Pay only for what you use

