require 'formula'

class WpCli < Formula
  homepage 'https://github.com/wp-cli/wp-cli'
  head 'https://github.com/wp-cli/wp-cli.git'
  url 'https://github.com/wp-cli/wp-cli/archive/v0.14.1.tar.gz'
  sha1 '5dff93c4528d2b44d2acda1ff0a06bd2de463acf'

  option 'without-bash-completion', "Don't install bash completion"
  option 'without-package-index', "Don't add package index repository (http://wp-cli.org/package-index)"

  depends_on 'composer'

  def install
    system "#{HOMEBREW_PREFIX}/bin/composer install"
    prefix.install Dir['*']

    if build.with? 'bash-completion'
      (prefix + 'etc/bash_completion.d').install "#{prefix}/utils/wp-completion.bash"
    end
    if build.with? 'package-index'
      system "#{HOMEBREW_PREFIX}/bin/composer config --file='#{prefix}/composer.json' repositories.wp-cli composer http://wp-cli.org/package-index/"
    end
  end

  def test
    system "#{bin}/wp --info"
  end
end
