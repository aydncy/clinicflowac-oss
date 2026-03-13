package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"clinicflow/internal/application/service"
)

type TokenVerifyHandler struct {
	service *service.TokenVerifyService
}

func NewTokenVerifyHandler(s *service.TokenVerifyService) *TokenVerifyHandler {
	return &TokenVerifyHandler{service: s}
}

type verifyRequest struct {
	Token string `json:"token" binding:"required"`
}

func (h *TokenVerifyHandler) Verify(c *gin.Context) {

	var req verifyRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := h.service.Verify(c.Request.Context(), req.Token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"valid": false})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"valid":  true,
		"claims": token.PrivateClaims(),
	})
}
