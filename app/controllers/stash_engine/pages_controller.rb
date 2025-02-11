require_dependency 'stash_engine/application_controller'

module StashEngine

  # a controller for some basic pages that really don't need a whole controller jut for them
  class PagesController < ApplicationController
    # the homepage shows latest plans and other things, so more than a static page
    def home
      @dataset_count = Resource.submitted_dataset_count
    end

    # The help controller uses the standard app layout, so the default is here.
    # Perhaps specific views would override it in the base application.
    def help
    end

    # The about controller uses the standard app layout, so the default is here.
    # Perhaps specific views would override it in the base application.
    def about
    end

    # produces a sitemap for the domain name/tenant listing the released datasets
    def sitemap
      respond_to do |format|
        format.xml do
          my_tenant = current_tenant
          identifs = Identifier.select(:id, :identifier, :identifier_type, :updated_at).distinct.
              joins('INNER JOIN stash_engine_resources ON ' \
                    'stash_engine_identifiers.id = stash_engine_resources.identifier_id ' \
                    'INNER JOIN stash_engine_users ON stash_engine_resources.user_id = stash_engine_users.id').
              where('stash_engine_users.tenant_id = ?', my_tenant.tenant_id)
          puts identifs.length

          render text: gen_xml_from_identifiers(identifs, my_tenant), layout: false
        end
      end
    end

    # an application 404 page to make it look nicer
    def app_404
      render :status => :not_found
    end

    private

    def gen_xml_from_identifiers(ar_identifiers, my_tenant)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') {
          ar_identifiers.each do |iden|
            xml.url {
              xml.loc "https://#{my_tenant.full_domain}#{APP_CONFIG.stash_mount}/dataset/#{iden.to_s}"
              xml.lastmod iden.updated_at.strftime('%Y-%m-%d')
            }
          end
        }
      end
      builder.to_xml
    end
  end
end
