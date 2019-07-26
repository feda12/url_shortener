class ShortenedUrlSerializer < ActiveModel::Serializer
  # This is tested through the controller specs
  attributes :url

  def url
    req = instance_options[:request]

    port = req.port != 80 ? req.port : nil

    URI::Generic.build(scheme: req.scheme,
                       host: req.host,
                       port: port,
                       path: "/#{object.slug}")
  end
end
