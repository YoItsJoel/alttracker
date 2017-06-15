defmodule Cryptofolio.Dashboard.Trade do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cryptofolio.Dashboard.Trade

  schema "trades" do
    belongs_to :currency, Cryptofolio.Dashboard.Currency

    field :amount, :decimal
    field :cost, :decimal
    field :date, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(%Trade{} = trade, attrs) do
    trade
    |> cast(attrs, [:amount, :cost, :date])
    |> cast_assoc(:currency)
    |> validate_required([:amount, :cost, :date, :currency_id])
  end
end