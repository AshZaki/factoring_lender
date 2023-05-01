# Factoring Lender API

## Requirements
Docker Compose
## Setup
1. Run `docker-compose up redis db`
2. If first time starting the project, run migrations: `docker-compose run rails rails db:create db:migrate`
3. Run `docker-compose up rails sidekiq`
4. Connect to API at http://127.0.0.1:3000 with provided Postman collection.

If you stop or make changes to the service, you can `docker-compose up --build` to rebuild the project.

## Testing
To run the rspec test suite, simply run `docker-compose run rails bundle exec rspec spec`
*Note:* this will wipe the database between tests!

In addition to the rspec tests, there is a Postman collection that has what you should need to test the rest of the functionality.
To see the fee update:
1. Create a client
2. Create an invoice for that client
3. Use the Patch request to transition the invoice status to `approved` and then to `purchased` (order matters). This will automatically set the `purchased_at` datetime field.
4. Use the `Patch purchased_at` request to change the datetime to a date in the past. This is necessary because the logic in the `accrue_fee!` method does `current date - purchased_at` and uses that in its formula for updating the fee table. The scheduler (Sidekiq) runs at the top of every minute, but that can be configured by the cronjob in `config/sidekiq.yml`. Ideally, the scheduler would maybe run once per day.
5. Use the GET invoices to see the accumulated value.
