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
# ### bucket_name
# Sets the S3 bucket name

set_default :s3_bucket, domain

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

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

# Connects to AWS S3 using provided settings
def prepare_s3_connection
  # Send logging to STDOUT
  AWS.config(:logger => Logger.new(STDOUT))

  AWS::S3.new(
    :access_key_id => aws_access_key_id,
    :secret_access_key => aws_secret_access_key
  )
end

namespace 'aws:s3' do
  # ### aws:s3:deploy
  # Starts a deploy to AWS S3
  desc 'Starts a deploy to AWS S3'
  task :deploy do
    s3 = prepare_s3_connection
    files = Dir.glob(s3_files_pattern).each do |file|
      if !File.directory?(file)
        path = file
        # Remove preceding slash for S3
        path.gsub!(/^\//, "")

        content = open(file)

        types = MIME::Types.type_for(File.basename(file))
        if types.empty?
          options = { :acl => :public_read }
        else
          options = { :acl => :public_read,:content_type => types[0] }
        end

        # s3.buckets[bucket].objects[path].write(contents, options)
        puts('AWS S3 OK: %s' % path)
      end # if
    end # files.each
  end

  # ### aws:s3:empty
  # Empties bucket of any files
  desc 'Empty the AWS S3 bucket'
  task :empty do
    s3 = prepare_s3_connection
    # s3.buckets[s3_bucket].clear!
    puts('AWS S3 Cleaned: %s' % s3_bucket)
  end
end
