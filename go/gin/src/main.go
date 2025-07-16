package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

type StatusResponse struct {
	Status string `json:"status"`
}

func getUser(c *gin.Context) {
	c.JSON(http.StatusOK, StatusResponse{Status: "success"})
}

func healthcheck(c *gin.Context) {
	c.JSON(http.StatusOK, StatusResponse{Status: "success"})
}

func main() {
	// Set Gin to release mode in production
	gin.SetMode(gin.ReleaseMode)
	
	router := gin.Default()
	
	// Get PREFIX environment variable
	prefix := os.Getenv("PREFIX")
	
	var routeGroup *gin.RouterGroup
	if prefix != "" {
		routeGroup = router.Group(prefix)
	} else {
		routeGroup = router.Group("")
	}
	
	// Define routes
	routeGroup.GET("/user", getUser)
	routeGroup.GET("/healthcheck", healthcheck)
	
	// Start server on port 8080
	router.Run(":8080")
}