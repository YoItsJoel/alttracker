defmodule Cryptofolio.Web.TradeController do
  use Cryptofolio.Web, :controller

  alias Cryptofolio.Dashboard

  def index(conn, _params) do
    trades = Dashboard.list_trades_with_currency()
    render(conn, "index.html", trades: trades)
  end

  def new(conn, _params) do
    changeset = Dashboard.change_trade(%Cryptofolio.Dashboard.Trade{})
    currencies = Dashboard.list_currencies()
    render(conn, "new.html", changeset: changeset, currencies: currencies)
  end

  def create(conn, %{"trade" => trade_params}) do
    case Dashboard.create_trade(trade_params) do
      {:ok, trade} ->
        conn
        |> put_flash(:info, "Trade created successfully.")
        |> redirect(to: trade_path(conn, :show, trade))
      {:error, %Ecto.Changeset{} = changeset} ->
        currencies = Dashboard.list_currencies()
        render(conn, "new.html", changeset: changeset, currencies: currencies)
    end
  end

  def show(conn, %{"id" => id}) do
    trade = Dashboard.get_trade!(id)
    render(conn, "show.html", trade: trade)
  end

  def edit(conn, %{"id" => id}) do
    trade = Dashboard.get_trade!(id)
    changeset = Dashboard.change_trade(trade)
    currencies = Dashboard.list_currencies()
    render(conn, "edit.html", trade: trade, changeset: changeset, currencies: currencies)
  end

  def update(conn, %{"id" => id, "trade" => trade_params}) do
    trade = Dashboard.get_trade!(id)

    case Dashboard.update_trade(trade, trade_params) do
      {:ok, trade} ->
        conn
        |> put_flash(:info, "Trade updated successfully.")
        |> redirect(to: trade_path(conn, :show, trade))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", trade: trade, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    trade = Dashboard.get_trade!(id)
    {:ok, _trade} = Dashboard.delete_trade(trade)

    conn
    |> put_flash(:info, "Trade deleted successfully.")
    |> redirect(to: trade_path(conn, :index))
  end
end
