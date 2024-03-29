This repo contains my approach to the Cloud Resume Challenge which can be found here: https://cloudresumechallenge.dev/.

I utilized a domain I previously purchased from [Porkbun](https://porkbun.com/) and continue to have hosted there. I used a CNAME to handle redirection to CloudFront.

<H3>FRONTEND:</H3>
The frontend website is a modified template from HTML5UP: https://html5up.net/prologue.
<br><br>
In the footer of the resume page is a view counter that utilizes DynamoDB and a lambda function (written in Python 3.12) to track site views. The lambda URL is public but is restricted to calls from my URL (https://resume.robotra.sh) via CORS. The function URL is called via the counter.js file and an HTML class in index.html.
<H3>AWS</H3>
In AWS I've utilized the following services:

- **Organizations/IAM Identity Center:** I utilize prod and test accounts with IAM MFA access to manage my environment
- **S3 bucket:** NOT set as a static website and NO public access granted
- **CloudFront:** Handles the serving of private content from the S3 bucket
- **Certificate Manager:** Creates an SSL cert for the site, utilized by CloudFront (currently commented out as cert creation and requests delay testing significantly)
- **Lambda:** Houses the Python 3.12 script that updates the db in DynamoDB
- **DynamoDB:** Houses the current page view count

<H3>Terraform</H3>
The following services have been automated with Terraform:

- [S3 Bucket](/infra/s3bucket.tf)
    - CloudFront access permissions
    - Website contents uploaded with correct MIME types associated
- [CloudFront Distribution](/infra/cloudfront.tf)
    - OAC
    - Caching behavior
    - Origin
- [Certificate Manager](/infra/certificaterequest.tf)
    - Commented out temporarily to ease deploy/test time
    - SSL cert generated 
- [Lambda function](/infra/lambda.tf)
    - Accompanying [func.py](/infra/lambda/func.py) file packaged and uploaded as Lambda function
- [DynamoDB](/infra/dynamodb.tf)
    - Table created
    - Item created in table (view count)

<H3>TODO</H3>

- Modify page view counter to log hashed IPs and track unique views only.
- Expand on this README : )