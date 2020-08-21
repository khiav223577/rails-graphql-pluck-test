import React from 'react';
import { render } from 'react-dom';
import Provider from '../components/Provider';
import UserInfo from '../components/UserInfo';
import Library from '../components/Library';

render(
  <Provider>
    <UserInfo />
    <Library />
  </Provider>,
  document.querySelector('#root')
);
