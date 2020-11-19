# UUID Associations ActiveRecord
[![Build Status](https://travis-ci.com/mcelicalderon/uuid_associations-active_record.svg?branch=master)](https://travis-ci.com/mcelicalderon/uuid_associations-active_record)
[![Gem Version](https://badge.fury.io/rb/uuid_associations-active_record.svg)](https://badge.fury.io/rb/uuid_associations-active_record)

## Table of Contents

<!--ts-->
   * [UUID Associations ActiveRecord](#uuid-associations-activerecord)
      * [Table of Contents](#table-of-contents)
      * [Installation](#installation)
      * [Rationale](#rationale)
      * [Usage](#usage)
         * [Association Methods](#association-methods)
            * [Generated Methods](#generated-methods)
         * [Nested Attributes](#nested-attributes)
      * [Future Work](#future-work)
      * [Development](#development)
      * [Contributing](#contributing)
      * [License](#license)

<!-- Added by: mcelicalderon, at: Sun Aug  2 12:17:14 -05 2020 -->

<!--te-->

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uuid_associations-active_record'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install uuid_associations-active_record
```

## Rationale

This gem is the result of some research I did to find out if using UUIDs as DB primary keys is a good thing
(Rails added support for this!). On the process
I ran into [this article](https://tomharrisonjr.com/uuid-or-guid-as-primary-keys-be-careful-7b2aa3dcb439) (among many others).
If you read the article you'll see how UUIDs have benefits over using sequential Int values as primary keys, but also how
you should be aware of what does that imply in terms of performance or even amount of storage used.

One of the author's conclusions is that you should use Int or Bigint columns as your primary keys, but also add a column
with a UUID that you can use to reference your records when exposing them to the outside world. If you finish reading the article
you'll find out that not even this is the perfect solution, but at least it's a huge improvement to exposing your sequential
primary keys. This gem helps you implement this approach.

## Usage

Adding the gem to your Gemfile is all you need for the gem to start working if you are using Rails. If you are not, you
you can always install the gem and require it manually (probably right after you require active_record). Take a look at
specs if you want to use the gem with plain ActiveRecord as that is how they are setup.

What this gem does is add some useful methods to your ActiveRecord models by calling the good old association methods like
`has_many`, `belongs_to`, `has_and_belongs_to_many`. As you may already know, calling these methods creates multiple
methods on the calling model for you. I'll explain the ones we are interested in in the next section.

This gem also adds a helpful mechanism to handle nested attributes. This will also be explained in the next section.

That's it! That is what the gem does. This will allow you to pass UUIDs to your update or create operations instead
of the actual IDs. Be aware that this will of course require an additional (but simple) DB query. That is the cost of
hiding the actual IDs (I'd say it's not too costly).

Also be aware that the initial version of this gem is not very configurable,
so the only thing it checks before creating the methods is that the right side association
on the caller model has a column named `uuid`, doesn't take the column type into account.
I have tested with string columns in SQlite3 and UUID columns in Postgres.

### Association Methods

Lets explore the next example:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_and_belongs_to_many :posts
  # generates
  #
  # def post_ids=(ids)
  #   # Adds or deletes the association with posts based on the array of IDs received
  # end
  #
  # def post_ids
  #   # returns an array with all the post IDs
  # end

  has_many :comments
  # generates
  #
  # def comment_ids=(ids)
  #   # Adds or deletes the association with comments based on the array of IDs received
  # end
  #
  # def comment_ids
  #   # returns an array with all the comment IDs
  # end
end

# app/models/post.rb
class Post < ActiveRecord::Base
  has_and_belongs_to_many :users
  # generates
  #
  # def user_ids=(ids)
  #   # Adds or deletes the association with users based on the array of IDs received
  # end
  #
  # def user_ids
  #   # returns an array with all the user IDs
  # end
end

# app/models/comment.rb
class Comment < ActiveRecord::Base
  belongs_to :user
  # generates
  #
  # def user_id=(id)
  #   associates the comment with the user
  # end

  # def user_id
  #   returns the ID of the associated user
  # end
end
```

This gem will add two new methods for each call to one of the association methods.

#### Generated Methods

Calling any of these methods will also add the following methods to your model:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_and_belongs_to_many :posts
  # generates
  #
  # def post_uuids=(uuids)
  #   self.post_ids = Post.where(uuid: uuids).pluck(:id)
  # end
  #
  # def post_uuids
  #   posts.pluck(:uuid)
  # end

  has_many :comments
  # generates
  #
  # def comment_uuids=(uuids)
  #   self.comment_ids = Comment.where(uuid: uuids).pluck(:id)
  # end
  #
  # def comment_uuids
  #   comments.pluck(:uuid)
  # end
end

# app/models/post.rb
class Post < ActiveRecord::Base
  has_and_belongs_to_many :users
  # generates
  #
  # def user_uuids=(uuids)
  #   self.user_ids = User.where(uuid: uuids).pluck(:id)
  # end
  #
  # def user_uuids
  #   users.pluck(:uuid)
  # end
end

# app/models/comment.rb
class Comment < ActiveRecord::Base
  belongs_to :user
  # generates
  #
  # def user_uuid=(uuid)
  #   self.user_id = User.find_by!(uuid: uuid)
  # end

  # def user_id
  #   user.uuid
  # end
end
```

### Nested Attributes

Nested attributes don't generate additional methods, this gem just modifies one so you can update nested record using
the record's UUID instead of the actual ID. Let's explore the next example:

```ruby
class Post < ActiveRecord::Base
  has_many :comments

  accepts_nested_attributes_for :comments, allow_destroy: true
  # generates
  #
  # def comments_attributes=(attributes)
  #   # allows to create or update comments using this method on Post
  # end
end
```

ActiveRecord allows for `attributes` to be an array of hashes or a hash of hashes. Here are some examples of the payload
you can pass to `comments_attributes` by using this gem:

```ruby
# This is supported without this gem
[
  { id: 1, comment_body: 'updating comment with ID 1' },
  { id: 2, _destroy: true },
  { comment_body: 'this will create a new comment' }
]

# With the gem, you can use UUIDs instead
[
  { uuid: 'some-uuid', comment_body: 'updating comment with UUID: some-uuid' }.
  { uuid: 'other-uuid', _destroy: true },
  { comment_body: 'this will create a new comment' }
]
```

Here are some things to take into account:

1. If the nested model (Comment in the example) does not have a column named `uuid`, the gem will take no action, will
just preserve the original behavior.
1. If the hash has both the `:id` and `:uuid` keys, the record will be fetched by `id`, and `uuid` will be passed as an attribute.
1. When the hash has a `:uuid` key and no record is found for that key, an `ActiveRecord::RecordNotFound` error will be raised.
   If you want the behavior to be that a new record is created when not found by UUID, you can set the option `create_missing_uuids: true`
   on the `accepts_nested_attributes_for` call.

## Future Work

1. Not commonly used by me, but testing and adding these methods to a `has_one` relationship.
1. Raise not found error if the array of UUIDs is bigger that the array of IDs fetched with the `where` statement (ActiveRecord's behavior).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To run the specs with all the supported versions of ActiveRecord you can use:

```ruby
$ bundle exec appraisal install
$ bundle exec appraisal rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mcelicalderon/uuid_associations-active_record.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
