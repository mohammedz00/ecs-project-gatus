# Build the application

# Selecting the base image: alpine chosen as its minimalist and security-oriented
 FROM golang:1.26.4-alpine

# Creating a directory inside the container where subsequent commands will be executed. Also allows for relative paths to be used instead of full file paths 
 WORKDIR /app

 # Copying the dependencies into the container first, to optimise Docker layer cache
 COPY go.mod go.sum ./

 # Install the dependencies into the container
 RUN go mod download

 # Copy the rest of the source code into the container
 COPY . .

 # Build/compile the application (the output of this is an executable binary called /docker-gs-ping)
 RUN CGO_ENABLED=0 GOOS=linux go build -o /gatus

 # Exposing port 8080
 EXPOSE 8080

 # Run command
 CMD ["/gatus"]