defmodule Pento.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :question, :text
      add :answer, :text
      add :vote, :integer

      timestamps()
    end
  end
end
