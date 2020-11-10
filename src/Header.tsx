import React from "react";
import { Link } from "react-router-dom";
import { Box, BoxProps, Button } from "grommet";

import {
  Notification,
  Home as HomeIcon,
  VmMaintenance,
  GraphQl as GraphQlIcon,
} from "grommet-icons";
import { Routes } from "./routes";

const AppBox = (
  props: JSX.IntrinsicAttributes &
    BoxProps &
    React.ClassAttributes<HTMLDivElement> &
    React.HTMLAttributes<HTMLDivElement>
): JSX.Element => {
  return (
    <Box
      direction="row"
      justify="between"
      align="center"
      elevation="medium"
      pad={{ vertical: "small", horizontal: "medium" }}
      {...props}
    />
  );
};

export const Header = (): JSX.Element => {
  return (
    <AppBox>
      <Link to={Routes.Home}>
        <HomeIcon />
      </Link>
      <Button
        icon={<Notification />}
        onClick={
          // eslint-disable-next-line @typescript-eslint/no-empty-function
          (): void => {}
        }
      />
      <Button></Button>
      <Link to={Routes.Graphql}>
        <GraphQlIcon />
      </Link>
      <Link to={Routes.Admin}>
        {/* <Link to="https://google.com"> */}
        <VmMaintenance />
      </Link>
    </AppBox>
  );
};
