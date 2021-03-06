#!/bin/bash
#
#   Copyright 2012 Timothy Lebo
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

if [[ "$1" == "--help" ]]; then
   echo "usage: `basename $0` [-n]"
   echo ""
   echo "  Run each conversion cockpit's publish/bin/publish.sh"
   echo "    Processing is controlled by CSV2RDF4LOD_ environment variables in the usual way."
   echo ""
   echo "   -n:         dry run; do not actually run scripts."
   exit 1
fi

see="https://github.com/timrdf/csv2rdf4lod-automation/wiki/CSV2RDF4LOD-not-set"
CSV2RDF4LOD_HOME=${CSV2RDF4LOD_HOME:?"not set; source csv2rdf4lod/source-me.sh or see $see"}

# cr:data-root cr:source cr:directory-of-datasets cr:dataset cr:directory-of-versions cr:conversion-cockpit
ACCEPTABLE_PWDs="cr:data-root cr:source cr:dataset cr:directory-of-versions cr:conversion-cockpit"
if [ `${CSV2RDF4LOD_HOME}/bin/util/is-pwd-a.sh $ACCEPTABLE_PWDs` != "yes" ]; then
   ${CSV2RDF4LOD_HOME}/bin/util/pwd-not-a.sh $ACCEPTABLE_PWDs
   exit 1
fi

dryrun="false"
if [ "$1" == "-n" ]; then
   dryrun="true"
   dryrun.sh $dryrun beginning
   shift 
fi

for script in `find . -name "publish.sh"`; do 
   pushd ${script%publish/bin/publish.sh} &> /dev/null
      if [[ `is-pwd-a.sh cr:conversion-cockpit` == "yes" ]]; then
         if [ "$dryrun" != "true" ]; then
            publish/bin/publish.sh
         else
            cr-pwd.sh
         fi
      fi
   popd &> /dev/null
done

dryrun.sh $dryrun ending
