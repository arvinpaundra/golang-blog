FROM golang:1.18 as builder

# Initialize the workdir
WORKDIR /app

# Copy go.mod and go.sum to workdir
COPY go.mod ./
COPY go.sum ./

# Install dependencies
RUN go mod download

# Copy all files to workdir
COPY . .

# Build go to binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Setup multistage build
FROM golang:alpine

WORKDIR /root

# Copy the first build to new workdir
COPY --from=builder /app/main .

# Expose port
EXPOSE 8080

# Run app
CMD ["./main"]