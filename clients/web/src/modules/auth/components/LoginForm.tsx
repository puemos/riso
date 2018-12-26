import { ErrorMessage, Field, Form, Formik } from "formik";
import gql from "graphql-tag";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import { connect } from "react-redux";
import { SignInMutation, SignInVariables } from "../../../generated/types";
import { getIsAuthenticated } from "../selectors";
import { AuthActions } from "../actions";
import { RootState } from "../../../store/root-reducer";
import { navigate } from "@reach/router";

const SIGNIN_MUTATION = gql`
  mutation signIn($input: SignInInput!) {
    signIn(input: $input) {
      result {
        token
      }
    }
  }
`;
type Props = {
  isAuthenticated: boolean;
  loggedIn: () => void;
  loggedOut: () => void;
};
type LoginFormValues = {
  email: string;
  password: string;
};

class FormikLoginForm extends Formik<LoginFormValues> {}

const LoginForm: React.SFC<Props> = React.memo(function(props) {
  const signIn = useMutation<SignInMutation, SignInVariables>(SIGNIN_MUTATION);

  return (
    <FormikLoginForm
      initialValues={{ email: "", password: "" }}
      onSubmit={async (values, actions) => {
        const { data } = await signIn({ variables: { input: values } });
        actions.setSubmitting(false);
        if (data!.signIn!.result) {
          localStorage.setItem("token", data!.signIn!.result!.token!);
          props.loggedIn();
          navigate("/positions");
        } else {
          localStorage.removeItem("token");
          props.loggedOut();
        }
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          <Field type="email" name="email" />
          <ErrorMessage name="email" component="div" />
          <Field type="password" name="password" />
          <ErrorMessage name="password" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Submit
          </button>
        </Form>
      )}
    </FormikLoginForm>
  );
});

const mapStateToProps = (state: RootState) => ({
  isAuthenticated: getIsAuthenticated(state.auth)
});

export default connect(
  mapStateToProps,
  {
    loggedIn: AuthActions.loggedIn,
    loggedOut: AuthActions.loggedOut
  }
)(LoginForm);
