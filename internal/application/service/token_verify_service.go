package service

import (
	"context"
	"errors"

	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/lestrrat-go/jwx/v2/jwk"
)

type TokenVerifyService struct {
	publicKey jwk.Key
}

func NewTokenVerifyService(pub jwk.Key) *TokenVerifyService {
	return &TokenVerifyService{
		publicKey: pub,
	}
}

func (s *TokenVerifyService) Verify(ctx context.Context, tokenString string) (jwt.Token, error) {

	token, err := jwt.Parse(
		[]byte(tokenString),
		jwt.WithKey(s.publicKey.Algorithm().(string), s.publicKey),
		jwt.WithValidate(true),
	)

	if err != nil {
		return nil, errors.New("invalid token")
	}

	return token, nil
}
