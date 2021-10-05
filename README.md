# README

# Blog Managment System (Coding challange)

## Demo Link
https://blog-managment.herokuapp.com/

## Dependencies
* Ruby: 3.0.2
* Rails: 6.1.4

## Configuration
```gem install bundler && bundle install```

## Database setup
```rake db:create && rake db:migrate && rake db:seed```

### Start Application USING FOREMAN

* In development mode:
```ruby
foreman start -f Procfile.dev
```

* In production mode:
```ruby
PORT=3000 foreman start -f Procfile
```

## Test environment setup
### Test database setup
```RAILS_ENV=test rake db:create && RAILS_ENV=test rake db:migrate```
### Run test suite
```rails test```

## Algolia Search Setup
* Create .env file and copy content from .env.sample
* Make an Aloglia account and copy the credentials(ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY)
* Set the Algolia credentials in .env file
