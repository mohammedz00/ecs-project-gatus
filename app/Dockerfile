### Build the application ###

# Selecting the base image: alpine chosen as its minimalist and security-oriented
 FROM golang:1.26.4-alpine AS build-stage

# Creating a directory inside the container where subsequent commands will be executed. Also allows for relative paths to be used instead of full file paths 
 WORKDIR /app

# Create a non-root user
 RUN addgroup -S appgroup && adduser -S appuser -G appgroup 

 # Copying the dependencies into the container first, to optimise Docker layer cache
 COPY go.mod go.sum ./

 # Install the dependencies into the container
 RUN go mod download

 # Copy the rest of the source code into the container
 COPY . .

 # Build/compile the application (the output of this is an executable binary called /docker-gs-ping)
 RUN CGO_ENABLED=0 GOOS=linux go build -o /gatus


 ### Run the application ###
 #FROM gcr.io/distroless/static-debian13
 FROM scratch

 # Get user password data from /etc/passwd
 COPY --from=build-stage /etc/passwd /etc/passwd
 COPY --from=build-stage /etc/group /etc/group
 
 # Copy executable from build stage into release stage and give ownership to the non-root user
 COPY --from=build-stage --chown=appuser:appgroup /gatus /gatus
 COPY --chown=appuser:appgroup config/config.yaml /config.yaml
 
 # Inject environment variable into container
 ENV GATUS_CONFIG_PATH=/config.yaml

 # Exposing port 8080 (more so just a comment for clarity)
 EXPOSE 8080

 # Run as non-root user
 USER appuser

 # Run command
 CMD ["/gatus"]

 # Test to trigger the docker pipeline/workflow


 