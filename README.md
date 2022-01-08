# Supabase migration

## What is this?
I like having things automatized and in git. After doing some projects with supabase and managing the migrations manually
I decided to make it automatic like it's supposed to be.
You can use this boilerplate code to get your supabase migration automated.

## How does it work
This boilerplate uses [@urbica/pg-migrate](https://github.com/urbica/pg-migrate) to run the migrations. It's uses the common pattern 
of using versioned files (using timestamp + name) for each step of your migration. Every time the migration is a success
it will add the name of a file in a table called migrations. The good thing about pg-migrate is that it runs the migrations
in a transaction so if you have a mistake in the query nothing changes.

## What about supabase webhooks
The biggest challenge I had were the big hooks. My latest project [Cavapi](https://cavapi.com?cm=supabase-migration-github) uses 
webhooks a lot (it has more than 10 webhooks). There were 2 reasons I couldn't leave the webhook migration as it is in the migration files.
1. Both the url and the token is different for the dev and prod environment so if I put them in the migration file I can't use the same file in both environments.
2. Putting secrets in the code is generally a bad idea!

Hence, I created a template like variables that will be replaced when the pipeline runs. Check out [Github pipline](piplines/github.yml) to see how it works.

## Using supabase-migration for an existing database
If you want to start using this boilerplate with your existing supabase database you can do the following
1. Use pg_dump to create a dump from your database in [useful commands section](#useful-commands)
2. Copy the content of the dump into your init file
3. For down part create a clean dump which provides you with all the down queries you need


## <a name="useful-commands"></a>Useful commands
Create a dump from your postgresql database:
```shell
pg_dump -h db.YOUR_SUPABASE_SUBDOMAIN.supabase.co -U postgres -n public --schema-only > dump.sql
```

Create **clean**(--clean) a dump from your postgresql database:
```shell
pg_dump -h db.YOUR_SUPABASE_SUBDOMAIN.supabase.co -U postgres --clean -n public --schema-only > dump.sql
```

Create a new migration
```shell
pg-migrate new my-new-migration
```

You can run any of the pg-migrate commands using the migrate.sh script. The connection data should be passed using environment variables
```shell
SUPABASE_HOST=db.YOUR_SUPABASE_SUBDOMAIN.supabase.co ./migrate.sh migrate
SUPABASE_HOST=db.YOUR_SUPABASE_SUBDOMAIN.supabase.co ./migrate.sh rollback 1
```

## How to contribute
Just make a PR :D

## Follow me
[twitter](https://twitter.com/moein_tech)
[medium](https://medium.com/@moein.akbarof)
[IndieHackers](https://www.indiehackers.com/moein)