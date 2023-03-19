module Increase
  class Resource
    class << self

      def get(path, params = {})
        response = connection.get(path, params)
        response.body
      end

      def post(path, params = {})
        response = connection.post(path, params)
        response.body
      end

      def put(path, params = {})
        response = connection.put(path, params)
        response.body
      end

      def delete(path, params = {})
        response = connection.delete(path, params)
        response.body
      end

      def resource_url
        "/#{resource_name.downcase}"
      end

      def resource_name
        if self == Resource
          raise NotImplementedError, "Resource is an abstract class. You should perform actions on its subclasses (Accounts, Transactions, Card, etc.)"
        end

        self.name.split('::').last
      end
    end

  end
end
