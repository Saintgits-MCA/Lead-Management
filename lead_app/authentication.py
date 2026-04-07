from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.exceptions import AuthenticationFailed
from .models import client_data
from django.core.cache import cache

# class ClientJWTAuthentication(JWTAuthentication):
#     def get_user(self, validated_token):
#         client_id = validated_token.get('client_id')

#         try:
#             return client_data.objects.get(id=client_id)
#         except client_data.DoesNotExist:
#             raise AuthenticationFailed('Client not found')

class ClientJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        jti = validated_token.get('jti')
        
        # Check if this JTI was blacklisted
        if cache.get(f"blacklist_access_{jti}"):
            raise AuthenticationFailed(
                detail='Token has been revoked',
                code='token_revoked'
            )

        client_id = validated_token.get('client_id')
        try:
            return client_data.objects.get(id=client_id)
        except client_data.DoesNotExist:
            raise AuthenticationFailed('Client not found')