using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Hkit.RNHkit
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNHkitModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNHkitModule"/>.
        /// </summary>
        internal RNHkitModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNHkit";
            }
        }
    }
}
