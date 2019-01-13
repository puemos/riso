import React, { Suspense } from "react";
import LoginForm from "../features/auth/components/LoginForm";

const LoginView: React.SFC<{ path: string }> = React.memo(function() {
  return (
    <div>
      <Suspense fallback="Loading...">
        <LoginForm />
      </Suspense>
    </div>
  );
});

export default LoginView;
