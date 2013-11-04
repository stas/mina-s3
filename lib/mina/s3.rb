require 'aws/s3'
require 'mime/types'
require 'logger'

# # Modules: AWS S3
# Adds settings and tasks for uploading to AWS S3
#
#     require 'mina/s3'
#
# ## Settings
# Any and all of these settings can be overwritten in your `deploy.rb`.
#
# ### s3_bucket_name
# Sets the S3 bucket name

set_default :s3_bucket_name, domain

# ### aws_access_key_id
# Sets the default AWS S3 access key ID

set_default :aws_access_key_id, 'CHANGE THIS'

# ### aws_secret_access_key
# Sets the default AWS S3 secret access key

set_default :aws_secret_access_key, 'CHANGE THIS'

# ### s3_files_pattern
# Sets the default pattern to match files needed to be uploaded
# Take a look at `Dir.glob` for examples
# Defaults to: ['assets/**/**', '*.html', '*.css']

set_default :s3_files_pattern, ['assets/**/**', '*.html', '*.css']

# ### s3_move_from_to
# Renames local files location
# Ex.: {:from => 'public/', :to => ''}
#   will rename everything in public dir to root dir on S3
# Defaults to: false

set_default :s3_move_from_to, false

# ### s3_region
# Sets the AWS region
set_default :s3_region, 'us-east-1'

# ### s3
# Sets the s3 connection object

set_default :s3, proc{
  # Send logging to STDOUT
  AWS.config(:logger => Logger.new(STDOUT)) if verbose_mode?

  AWS::S3.new(
    :access_key_id => aws_access_key_id,
    :secret_access_key => aws_secret_access_key,
    :region => s3_region
  )
}

# ### s3_bucket
# Sets the s3 bucket
set_default :s3_bucket, proc { s3.buckets[s3_bucket_name] }

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

namespace 'aws:s3' do
  # ### aws:s3:deploy
  # Starts a deploy to AWS S3
  desc 'Starts a deploy to AWS S3'
  task :deploy do
    print_str '-----> Starting AWS S3 deployment'
    Dir.glob(s3_files_pattern).each do |file|
      if !File.directory?(file)
        path = file

        contents = open(file)

        # Do some renaming if any
        path.gsub!(s3_move_from_to[:from], s3_move_from_to[:to]) if s3_move_from_to
        # Remove preceding slash for S3
        path.gsub!(/^\//, "")

        types = MIME::Types.type_for(File.basename(file))
        if types.empty?
          options = { :acl => :public_read }
        else
          options = { :acl => :public_read,:content_type => types[0] }
        end

        s3_bucket.objects[path].write(contents, options)
        print_str 'Deployed ~> %s%s' % [s3_bucket.url, path]
      end # if
    end # each
  end

  # ### aws:s3:empty
  # Empties bucket of any files
  desc 'Empty the AWS S3 bucket'
  task :empty do
    s3_bucket.clear!
    print_str '-----> Cleaned %s' % s3_bucket.url
  end
end
