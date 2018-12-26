import React from "react";
import LoginForm from "../features/auth/components/LoginForm";

const LoginView: React.SFC<{ path: string }> = React.memo(function() {
  return (
    <div>
      <LoginForm />
    </div>
  );
});

export default LoginView;
