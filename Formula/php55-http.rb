require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php55Http < AbstractPhp55Extension
  init
  homepage 'http://pecl.php.net/package/pecl_http'
  url 'http://pecl.php.net/get/pecl_http-2.0.5.tgz'
  sha1 'b3585b18322a448861f07d6f5c8a2721d030baac'
  head 'https://git.php.net/repository/pecl/http/pecl_http.git'

  depends_on 'curl' => :build
  depends_on 'libevent' => :build
  depends_on 'php55-raphf'
  depends_on 'php55-propro'

  # overwrite the config file name to ensure extension is loaded after dependencies
  def config_filename; "zzz_ext-" + extension + ".ini"; end

  def install
    Dir.chdir "pecl_http-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize

    # link in the raphf extension header
    system "mkdir -p ext/raphf"
    cp "#{Formula['php55-raphf'].opt_prefix}/include/php_raphf.h", "ext/raphf/php_raphf.h"

    # link in the propro extension header
    system "mkdir -p ext/propro"
    cp "#{Formula['php55-propro'].opt_prefix}/include/php_propro.h", "ext/propro/php_propro.h"

    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-libevent-dir=#{Formula['libevent'].opt_prefix}",
                          "--with-curl-dir=#{Formula['curl'].opt_prefix}"
    system "make"
    prefix.install "modules/http.so"
    write_config_file if build.with? "config-file"

    # remove old configuration file
    old_config_filepath = config_scandir_path / "ext-http.ini"
    if File.exist?(old_config_filepath)
      system "unlink " + old_config_filepath
    end
  end
end
