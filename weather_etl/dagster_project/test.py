from dagster import job, op

@op
def hello_op():
    print("Hello from Dagster job! Pipeline works.")

@job
def weather_etl_job():
    hello_op()

