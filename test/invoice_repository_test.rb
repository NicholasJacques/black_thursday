require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_repository'
require 'simplecov'

class InvoiceRepositoryTest < Minitest::Test

  def test_it_exists
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoice_one.csv'})
    inr = sa.invoices

    assert_instance_of InvoiceRepository, inr
  end

  def test_all_method_returns_all_invoices
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoices_three.csv'})
    inr = sa.invoices

    assert_instance_of Array, inr.all
    assert_equal 3, inr.all.length
    assert_equal 1,inr.all.first.id
  end

  def test_it_knows_its_parent
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoices_three.csv'})
    inr = sa.invoices

    assert_instance_of SalesEngine, inr.parent
  end

  def test_can_find_invoice_by_id
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoices_three.csv'})
    inr = sa.invoices

    assert_instance_of Invoice, inr.find_by_id(2)
    assert_equal 12334753, inr.find_by_id(2).merchant_id
    assert_nil inr.find_by_id(5)
  end

  def test_find_all_by_customer_id
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoices_three.csv'})
    inr = sa.invoices

    assert_instance_of Array, inr.find_all_by_customer_id(1)
    assert_instance_of Invoice, inr.find_all_by_customer_id(1).first
    assert_equal 2, inr.find_all_by_customer_id(1).length
    assert_equal [], inr.find_all_by_customer_id(3)
  end

  def test_find_all_by_merchant_id
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoices_three.csv'})
    inr = sa.invoices

    assert_instance_of Array, inr.find_all_by_merchant_id(12335938)
    assert_instance_of Invoice, inr.find_all_by_merchant_id(12335938).first
    assert_equal 2, inr.find_all_by_merchant_id(12335938).length
    assert_equal [], inr.find_all_by_merchant_id(42365338)
  end

  def test_find_all_by_status
    sa = SalesEngine.from_csv({:invoices => './test/fixtures/invoices_three.csv'})
    inr = sa.invoices

    assert_instance_of Array, inr.find_all_by_status("shipped")
    assert_instance_of Invoice, inr.find_all_by_status("shipped").first
    assert_equal 2, inr.find_all_by_status("shipped").length
    assert_equal [], inr.find_all_by_status("returned")
  end

  def test_find_merchant
    se = SalesEngine.from_csv({:merchants => './test/fixtures/merchant_matches.csv',
                               :items => './test/fixtures/items_same_merchant_id.csv',
                               :invoices => './test/fixtures/invoices_three.csv'})
    inr = se.invoices

    assert_instance_of Merchant, inr.find_merchant(12335938)
  end
end