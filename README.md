# IAM Role S3 downloader

Securely download files from S3 to EC2 instances using IAM roles.

More info in [the AWS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingIAM.html#UsingIAMrolesWithAmazonEC2Instances).

## Background

When setting up new EC2 instances using tools like [Chef Solo](http://docs.opscode.com/chef_solo.html) you might have some sensitive files that needs to exist on the new instance in order to start the setup. A good tool for this pre-setup is using [Cloud init](https://help.ubuntu.com/community/CloudInit) to download the required files, however you don't always want these files to be publicly available for everyone.

A solution for this is using a non-public S3 bucket together with a IAM role that allows access to the bucket. EC2 instances that has this role assigned can acquire temporary access to files stored in S3 buckets without actually storing any credentials locally.

More details:

* [IAM roles for EC2 instances – Simplified Secure Access to AWS service APIs from EC2](http://aws.typepad.com/aws/2012/06/iam-roles-for-ec2-instances-simplified-secure-access-to-aws-service-apis-from-ec2.html)
* [How can I (securely) download a private S3 asset onto a new EC2 instance with cloudinit?](http://stackoverflow.com/questions/11365730/how-can-i-securely-download-a-private-s3-asset-onto-a-new-ec2-instance-with-cl)

## Usage

```
$ ./iam-s3-downloader.rb --help
Usage: ./iam-s3-downloader.rb [options]
        --bucket BUCKET              Bucket to fetch file from. Required.
        --key KEY                    Key to fetch (name on S3). Required.
        --destination PATH           Local path for saved key. Defaults to ./KEY.
        --role-url URL               URL for IAM role. Defaults to http://169.254.169.254/latest/meta-data/iam/security-credentials/s3access
```
