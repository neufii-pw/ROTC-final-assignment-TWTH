# use official Golang image
FROM golang:1.20-alpine AS Builder
# set working directory
WORKDIR /app
# Copy the source code
COPY . .
# Download and install the dependencies
RUN go mod download
# Build the Go app
RUN go build -o api .

# Create runtime image
FROM alpine:latest
# set working directory
WORKDIR /
# Get api binary from the builder image
COPY --from=Builder /app/api /app/api
#EXPOSE the port
EXPOSE 8000
# Run the executable
CMD ["/app/api"]
