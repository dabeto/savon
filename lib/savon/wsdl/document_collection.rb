require 'uri'

class Savon
  class WSDL
    class DocumentCollection
      include Enumerable

      def initialize
        @documents = []
      end

      def <<(document)
        @documents << document
      end

      def each(&block)
        @documents.each(&block)
      end

      def service_name
        @service_name ||= first.service_name
      end

      def messages
        @messages ||= collect_sections { |document| document.messages }
      end

      def port_types
        @port_types ||= collect_sections { |document| document.port_types }
      end

      def bindings
        @bindings ||= collect_sections { |document| document.bindings }
      end

      def services
        @services ||= collect_sections { |document| document.services }
      end

      # Public: Returns a port by service and port name.
      def service_port(service_name, port_name)
        service = services.fetch(service_name)
        service.ports.fetch(port_name)
      end

      private

      def collect_sections
        result = {}

        each do |document|
          sections = yield document
          result.merge! sections
        end

        result
      end

    end
  end
end
