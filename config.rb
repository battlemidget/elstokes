Time.zone = "US/Eastern"

# Per-page layout changes:
page "/sitemap.xml", :layout => false
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###
helpers do
  def page_title
    if content_for?(:title)
      "#{yield_content(:title)} - Adam Stokes"
    end
  end
  def page_description
    if content_for?(:description)
      "#{yield_content(:description)}"
    end
  end

end

ready do
  blog.tags.each do |tag, posts|
    proxy "/tags/#{tag.downcase.tr(" ", "_")}/feed.xml",
          "/tag.xml",
          locals: { tag: tag, posts: posts },
          ignore: true,
          layout: false
  end
end

activate :directory_indexes

# syntax
activate :syntax, :line_numbers => true
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true, with_toc_data: true, strikethrough: true, superscript: true

# blog
activate :blog do |blog|
  blog.layout = "post.slim"
  blog.permalink = "/{title}/index.html"
  blog.paginate = false
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"
  blog.year_link = "blog/{year}.html"
  blog.month_link = "blog/{year}/{month}.html"
  blog.day_link = "blog/{year}/{month}/{day}.html"
end

activate :disqus do |d|
  d.shortname = 'astokes'
end

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :slim, {
  :format => :html,
  :indent => '  ',
  :pretty => true,
  :sort_attrs => false
}
::Slim::Engine.disable_option_validator!

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Minify html
  activate :minify_html

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host = 'ssh.astokes.org'
  deploy.path = '/srv/blog'
  deploy.user = 'root'
  deploy.clean = true
  deploy.flags = '-avz --chown=www-data:www-data'
  deploy.build_before = true
end

# set site configs
set :site_description, 'got lost in walmart, /me scared'
set :site_author, 'Adam Stokes'
set :social_links, {
  twitter: 'https://twitter.com/battlemidget',
  github: 'https://github.com/battelmidget',
  linkedin: 'https://linkedin.com/stokachu'
}
