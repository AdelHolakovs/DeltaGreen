# Weather ETL Pipeline

This repository provides an end-to-end ETL pipeline for collecting weather data from [WeatherAPI.com](https://www.weatherapi.com/) every 15 minutes for Prague and London. The data is stored in a PostgreSQL database running in Docker and can be queried in a Jupyter Notebook for analysis.

## Project Structure

```
weather_etl/
├── docker-compose.yml           # Defines Postgres service and initialization
├── docker/
│   └── init_db/
│       └── create_tables.sql    # SQL schema for weather_current and weather_forecast tables
├── etl/
│   ├── flow.py                  # Prefect flow to extract, transform and load data
│   └── requirements.txt         # Python dependencies for ETL
├── notebooks/
│   └── load_forecasts.ipynb     # Jupyter Notebook to load latest hourly forecasts
└── README.md                    # Project overview and setup instructions
```

## Prerequisites

* Docker & Docker Compose
* Python 3.8+ with virtualenv
* A free WeatherAPI.com API key (register to activate 14‑day trial, then switch to free tier)

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-org/weather_etl.git
   cd weather_etl
   ```

2. **Create environment file**
   In the `etl/` folder, create a `.env` file with your WeatherAPI key:

   ```dotenv
   WEATHERAPI_KEY=your_api_key_here
   POSTGRES_HOST=localhost
   POSTGRES_PORT=5432
   POSTGRES_DB=weatherdb
   POSTGRES_USER=weather
   POSTGRES_PASSWORD=secret
   ```

3. **Start PostgreSQL in Docker**

   ```bash
   docker-compose up -d
   ```

   This will:

   * Launch a Postgres container on port 5432
   * Initialize the `weather_current` and `weather_forecast` tables automatically

4. **Install ETL dependencies**

   ```bash
   cd etl
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

## Running the ETL Pipeline

The ETL pipeline is implemented using [Prefect](https://www.prefect.io/):

1. **Register the flow** (optional; for Prefect Cloud or Server):

   ```bash
   prefect register --project "Default" --path flow.py
   ```

2. **Start a Prefect agent** to execute scheduled runs:

   ```bash
   prefect agent local start
   ```

The flow is scheduled with a Cron schedule (`*/15 * * * *` Europe/Prague) to:

* Fetch current and 48‑hour forecast data for Prague and London
* Insert raw and forecast data into the database

## Querying Data in Jupyter

Open `notebooks/load_forecasts.ipynb` and:

1. Install dependencies:

   ```bash
   pip install psycopg2-binary sqlalchemy pandas
   ```
2. Run the cell to connect to the Postgres database and load the latest hourly forecasts per city.

## Next Steps

* Extend with data transformations (e.g., time zone handling, indexing)
* Add monitoring/alerts in Prefect for failures
* Visualize and compare forecasts vs. reality in a dashboard

---

Feel free to iterate on this pipeline or ask for any clarifications!
