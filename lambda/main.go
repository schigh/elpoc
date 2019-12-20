package main

import (
	"context"
	"errors"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/go-redis/redis/v7"
	"github.com/rs/zerolog"
)

// this just pops the last word off a sentence
func reduce(in string) string {
	fields := strings.Fields(in)
	lf := len(fields)
	if lf == 0 || lf == 1 {
		return ""
	}
	return strings.Join(fields[:lf-2], " ")
}

func main() {
	lambda.Start(func(ctx context.Context, event events.SQSEvent) error {
		logger := zerolog.New(os.Stdout).With().Timestamp().Logger()

		// just quit if there are no records.  this should never happen
		if len(event.Records) == 0 {
			err := errors.New("no records exist in the invocation")
			logger.Error().Err(err).Send()
			return err
		}

		// check environment variables
		redisEndpoint, ok := os.LookupEnv("ELASTICACHE_ENDPOINT")
		if !ok {
			err := errors.New("no ELASTICACHE_ENDPOINT environment variable set")
			logger.Error().Err(err).Send()
			return err
		}

		sqsOut, ok := os.LookupEnv("SQS_OUT")
		if !ok {
			err := errors.New("no SQS_OUT environment variable set")
			logger.Error().Err(err).Send()
			return err
		}

		// create redis client
		client := redis.NewClient(&redis.Options{
			Addr: redisEndpoint,
		})

		if err := client.Ping().Err(); err != nil {
			logger.Error().Err(err).Send()
			return err
		}

		record := event.Records[0]

		word := record.Body
		if word == "" {
			err := errors.New("the word cannot be empty")
			logger.Error().Err(err).Send()
			return err
		}

		word = reduce(word)

		if word == "" {
			// we're done
			return nil
		}

		// record the word in history

		// push to recipient queue
		sess, err := session.NewSession()
		if err != nil {
			return err
		}

		queue := sqs.New(sess)
		return nil
	})
}
