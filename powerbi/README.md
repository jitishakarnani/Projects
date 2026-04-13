# Power BI Report File

## File: `sales_dashboard.pbix`

The Power BI `.pbix` file is the compiled report containing:
- All 4 dashboard pages
- 10 custom DAX measures
- Data model and relationships
- Slicers and cross-page filters

## How to Obtain / Recreate

Since `.pbix` files can be large, you have two options:

### Option A — Download from Releases
Check the [GitHub Releases](../../releases) page for the latest `sales_dashboard.pbix` attached as a release asset.

### Option B — Build from Scratch
1. Import `data/sample_data.csv` into Power BI Desktop
2. Create the Date Table using the DAX in [`docs/dax_measures.md`](../docs/dax_measures.md)
3. Add all 10 measures from the same file
4. Build the 4 report pages following [`docs/dashboard_guide.md`](../docs/dashboard_guide.md)

## Connecting to Your Database
1. Open Power BI Desktop
2. **Home → Get Data → PostgreSQL** (or your DB type)
3. Server: `localhost` | Database: `your_db_name`
4. Select the view `vw_powerbi_export`
5. Click **Load**
