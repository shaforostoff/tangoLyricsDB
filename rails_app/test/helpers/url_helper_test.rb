require "test_helper"

class UrlHelperTest < ActiveSupport::TestCase
  include UrlHelper

  # test_helper stubs check_url so other tests stay offline; call the real one
  def real_check_url(url)
    method = UrlHelper.instance_method(:check_url)
    method = method.super_method until method.owner == UrlHelper
    method.bind_call(self, url)
  end

  test "accepts public addresses" do
    assert_equal "8.8.8.8", public_address("8.8.8.8")
  end

  test "refuses addresses inside the VM or private networks" do
    %w[127.0.0.1 10.138.0.7 172.18.0.2 192.168.1.1 169.254.169.254 100.64.0.1 0.0.0.0 ::1 fd00::1 ::ffff:127.0.0.1 localhost].each do |host|
      assert_nil public_address(host), host
    end
  end

  test "refuses to check internal or unusual URLs" do
    [ "http://169.254.169.254/computeMetadata/v1/", "http://localhost/", "http://10.0.0.1/",
      "http://example.com:8080/", "ftp://example.com/" ].each do |url|
      assert_nil real_check_url(url), url
    end
  end
end
