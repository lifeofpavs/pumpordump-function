require 'dotenv/load'

# FirebaseVerifier - Verify FirebaseTokencont
class FirebaseVerifier
  def self.verify_firebase_token(firebase_token)
    # Fetch the JSON Web Key Set (JWKS)
    jwks = fetch_jwks

    # Decode the JWT without verifying the signature to get the key ID (kid)
    header = JWT.decode(firebase_token, nil, false)[1]

    # Find the corresponding certificate for the key ID (kid)
    certificate = jwks[header['kid']]

    # Verify the JWT using the correct certificate
    decoded_token = JWT.decode(
      firebase_token,
      OpenSSL::X509::Certificate.new(certificate).public_key,
      true,
      algorithm: 'RS256'
    )

    # The decoded payload
    return decoded_token.first if decoded_token.first['aud'] == ENV['FIREBASE_PROJECT_ID']

    nil
    # Perform additional checks if needed (e.g., check the 'aud' claim for your Firebase project ID)

    # Return the decoded payload
  end

  def self.fetch_jwks
    jwks_url = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'
    uri = URI.parse(jwks_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0' })
    response = http.request(request)

    JSON.parse(response.body)
  end
end
