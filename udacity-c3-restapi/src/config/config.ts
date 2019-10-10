export const config = {
  "dev": {
    "username": process.env.UDCD_POSTGRES_USERNAME,
    "password": process.env.UDCD_POSTGRES_PASSWORD,
    "database": process.env.UDCD_POSTGRES_DATABASE,
    "host": process.env.UDCD_POSTGRES_HOST,
    "dialect": "postgres",
    "aws_region": process.env.UDCD_AWS_REGION,
    "aws_profile": process.env.UDCD_AWS_PROFILE,
    "aws_media_bucket": process.env.UDCD_AWS_MEDIA_BUCKET
  },
  "prod": {
    "username": "",
    "password": "",
    "database": "udagram_prod",
    "host": "",
    "dialect": "postgres"
  },
  "jwt": {
    "secret": process.env.UDCD_JWT_SECRET
  }
};
