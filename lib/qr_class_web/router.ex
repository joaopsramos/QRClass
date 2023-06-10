defmodule QRClassWeb.Router do
  use QRClassWeb, :router

  import QRClassWeb.UserAuth
  alias QRClassWeb.StoreIP

  @ensure_authenticated {QRClassWeb.UserAuth, :ensure_authenticated}
  @redirect_if_authenticated {QRClassWeb.UserAuth, :redirect_if_user_is_authenticated}

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {QRClassWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :qr_code do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {QRClassWeb.Layouts, :qr_code})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(StoreIP)
  end

  scope "/api", QRClassWeb do
    pipe_through(:api)

    get("/classes", ClassController, :index)
    post("/classes", ClassController, :create)
    post("/classes/:class_id/sessions", ClassController, :create_class_session)

    get("/teachers", TeacherController, :index)
    get("/students", StudentController, :index)
  end

  scope "/", QRClassWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user, on_mount: [@ensure_authenticated] do
      live("/classes/:id", ClassLive.Show, :show)
      live("/classes/:id/class_session/:class_session_id/qr_code", ClassLive.Show, :edit)

      live("/teacher", TeacherLive.Index, :index)
      live("/class_sessions/:id", ClassSessionLive.Index, :index)

      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
    end
  end

  ## Authentication routes

  scope "/", QRClassWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/", PageController, :home)
    get("/student/account_created", PageController, :account_created)

    live_session :redirect_if_user_is_authenticated, on_mount: [@redirect_if_authenticated] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", QRClassWeb do
    pipe_through([:qr_code])

    live("/attendance", AttendanceLive.Index, :index)
  end

  scope "/", QRClassWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{QRClassWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:qr_class, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: QRClassWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
