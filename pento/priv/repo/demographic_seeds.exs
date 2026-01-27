import Ecto.Query
alias Pento.Accounts.User
alias Pento.Catalog.Product
alias Pento.{Repo, Accounts, Survey}

user_ids = Repo.all(from(u in User, select: u.id))

genders = ["female", "male", "other", "prefer not to say"]

education_levels = [
  "high school",
  "bachelor's degree",
  "graduate degree",
  "other",
  "prefer not to say"
]

years = 1960..2008

for uid <- user_ids do
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(genders),
    education_level: Enum.random(education_levels),
    year_of_birth: Enum.random(years)
  })
end
