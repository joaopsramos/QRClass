# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QRClass.Repo.insert!(%QRClass.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias QRClass.Accounts

# QRClass.Accounts.register_user(%{
#   type: Accounts.student(),
#   email: "aluno@teste.com",
#   password: "564231564231"
# })

QRClass.Accounts.register_user(%{
  type: Accounts.teacher(),
  email: "prof@teste.com",
  password: "564231564231"
})
